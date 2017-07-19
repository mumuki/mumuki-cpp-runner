require_relative 'spec_helper'

def req(content, test='')
  struct content: content, test: test
end

describe CppFeedbackHook do

  before {I18n.locale = :es}

  let(:server) {CppTestHook.new}
  let!(:test_results) {server.run!(server.compile(request))}
  let(:feedback) {CppFeedbackHook.new.run!(request, OpenStruct.new(test_results: test_results))}

  context 'has_no_member_named' do
    let(:request) {req('class Foo {};', %q{
      void testFoo(){
        Foo* foo = new Foo();
        foo->foo();
        delete foo;
      }
    })}

    it {expect(feedback).to include('* Parece que no existe el campo, atributo o método `foo` en `class Foo`. Revisá en esta parte `foo->foo();` que exista o el nombre esté bien escrito.')}
  end

  context 'was_not_declared_in_this_scope' do
    let(:request) {req('void bar() {foo == 4;}')}

    it {expect(feedback).to include('* El identificador `foo` no existe. Revisá en esta parte `void bar() {foo == 4;}` si está bien escrito o si estás usando la variable correcta.')}
  end

  context 'does_not_a_type' do
    let(:request) {req('doble a = 0.0;')}

    it {expect(feedback).to include('* No hay un tipo de dato con el nombre `doble`. Revisá en esta parte `doble a = 0.0;` si está bien escrito.')}
  end

  context 'has_incomplete_type_and_cannot_be_defined' do
    let(:request) {req('struct Registro; Registro variable;')}

    it {expect(feedback).to include('* Parece que no definiste el tipo `Registro variable`. Revisá en esta parte `struct Registro; Registro variable;` que el nombre esté bien escrito.')}
  end

  context 'invalid_suffix' do
    let(:request) {req('void 2foo() {}')}

    it {expect(feedback).to include('* Parece que intentaste definir un identificador `foo` no válido. Revisá en esta parte `void 2foo() {}` si lo empezaste con un número. Recordá que los nombres de los identificadores deben comenzar con una **letra**, **$** o **_** (guión bajo).')}
  end

  context 'expected_comma_before_token' do
    let(:request) {req('void foo(int a.b) {}')}

    it {expect(feedback).to include('* El nombre de uno de los parámetros está mal. Revisá en esta parte `void foo(int a.b) {}` que no tenga puntos en el nombre.')}
  end

  context 'expected_initializer_before_token' do
    let(:request) {req('int a.b;')}

    it {expect(feedback).to include('* El nombre de una de las variables está mal. Revisá en esta parte `int a.b;` que no tenga puntos en el nombre.')}
  end

  context 'too_many_arguments_to_function' do
    let(:request) {req(%q{
      void foo() {
        foo(1);
      }
    })}

    it {expect(feedback).to include('* Parece que invocaste a la función `void foo()` con más argumentos de los que lleva. Revisá en esta parte `foo(1);` la llamada a la función.')}
  end

  context 'too_few_arguments_to_function' do
    let(:request) {req(%q{
      void foo(int a) {
        foo();
      }
    })}

    it {expect(feedback).to include('* Parece que invocaste a la función `void foo(int)` con menos argumentos de los que lleva. Revisá en esta parte `foo();` la llamada a la función.')}
  end

  context 'call_of_overloaded_is_ambiguous' do
    let(:request) {req(%q{
      void foo(int a) {}
      void foo(double a) {}
      void bar() {
        foo(1L);
      }
    })}

    it {expect(feedback).to include('* Uno o más argumentos están mal al invocar a `foo(long int)`. Revisá en esta parte `foo(1L);` con qué argumentos la estas llamando.')}
  end

  context 'invalid_conversion_from_to' do
    let(:request) {req(%q{
      void foo(int a) {}
      void bar() {
          foo("Bar");
      }
    })}

    it {expect(feedback).to include('* Se esperaba un valor de tipo `const char*` pero se recibió uno de `int` en esta línea `foo("Bar");`.')}
  end


  context 'expected_after_struct_definition' do
    let(:request) {req(%q{
      struct foo {
        int bar;
      }
    })}

    it {expect(feedback).to include('* Falta el `;` después de definir el registro.')}
  end

  context 'expected_initializer_before' do
    let(:request) {req(%q{
      int foo
      bar();
    })}

    it {expect(feedback).to include('* Probablemente falte un `;` después de declarar una variable en la línea anterior a `bar();`.')}
  end

  context 'expected_unqualified_id' do
    let(:request) {req('int double = 1;')}

    it {expect(feedback).to include('* El identificador que se encuentra entes que `=` no es válido. Revisá en esta parte `int double = 1;`.')}
  end

  context 'expected_at_end_of_member' do
    let(:request) {req(%q{
      struct Foo {
        double bar
        double baz;
      };
    })}

    it {expect(feedback).to include('* Parece que campo, atributo o método está mal definido. Revisá en esta parte `double bar` si sobra o falta algún `;`.')}
  end

  context 'when same error occurs more than once  times in the same line' do
    let(:request) {req(%q{
      struct Foo;
      void Bar(SDL_Surface *screen, struct Foo);
      void Baz(SDL_Surface *screen, struct Foo);
    })}

    it {expect(feedback).to include('* El identificador `screen` no existe. Revisá en esta parte `void Bar(SDL_Surface *screen, struct Foo);` si está bien escrito o si estás usando la variable correcta.')}
  end

end
