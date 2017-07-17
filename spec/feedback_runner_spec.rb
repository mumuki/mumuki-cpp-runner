require_relative 'spec_helper'

def req(content, test)
  struct content: content, test: test
end

describe CppFeedbackHook do

  before {I18n.locale = :es}

  let(:server) {CppTestHook.new}
  let!(:test_results) {server.run!(server.compile(request))}
  let(:feedback) {CppFeedbackHook.new.run!(request, OpenStruct.new(test_results: test_results))}

  context 'has_no_member_named' do
    let(:test) {%q{
      class MumukiTest : public CppUnit::TestFixture {
        CPPUNIT_TEST_SUITE( MumukiTest );
          CPPUNIT_TEST( testFoo );
        CPPUNIT_TEST_SUITE_END();

        void testFoo()
        {
          Foo* foo = new Foo();
          CPPUNIT_ASSERT( foo->foo() == 4 );
          delete foo;
        }
      };
      }}
    let(:request) {req('class Foo {};', test)}

    it {expect(feedback).to eq('* Parece que no existe el campo `foo` en el tipo `class Foo`. Fijate que el nombre esté bien escrito.')}
  end

  context 'was_not_declared_in_this_scope' do
    let(:test) {%q{
      class MumukiTest : public CppUnit::TestFixture {
        CPPUNIT_TEST_SUITE( MumukiTest );
          CPPUNIT_TEST( testFoo );
        CPPUNIT_TEST_SUITE_END();

        void testFoo() {
          CPPUNIT_ASSERT( foo == 4 );
        }
      };
      }}
    let(:request) {req('', test)}

    it {expect(feedback).to eq('* El identificador `foo` no existe. Fijate si está bien escrito o si estás usando la variable correcta.')}
  end

  context 'does_not_a_type' do
    let(:request) {req('doble a = 0.0;', '')}

    it {expect(feedback).to eq('* No hay un tipo de datos con el nombre `doble`. Fijate si está bien escrito.')}
  end


  context 'has_incomplete_type_and_cannot_be_defined' do
    let(:request) {req('struct Registro; Registro variable;', '')}

    it {expect(feedback).to eq('* Parece que no definiste el tipo `Registro variable`. Fijate que el nombre esté bien escrito.')}
  end

end
