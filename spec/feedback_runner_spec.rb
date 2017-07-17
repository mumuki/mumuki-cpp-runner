require_relative 'spec_helper'

def req(content, test)
  struct content: content, test: test
end

describe CppFeedbackHook do

  before {I18n.locale = :es}

  let(:server) {CppTestHook.new}
  let!(:test_results) {server.run!(server.compile(request))}
  let(:feedback) {CppFeedbackHook.new.run!(request, OpenStruct.new(test_results: test_results))}

  context 'when identifier not defined' do
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

end
