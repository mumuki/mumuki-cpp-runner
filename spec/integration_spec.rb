require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) {Mumukit::Bridge::Runner.new('http://localhost:4568')}

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end
  after(:all) {Process.kill 'TERM', @pid}

  context 'answers a valid hash when submission passes' do
    let(:response) {bridge.run_tests!(test: %q{
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
};}, extra: '', content: %q{
class Foo {
  public:

  int foo() {
    return 4;
  }
};}, expectations: [])}

    it {expect(response).to eq response_type: :structured,
                               test_results: [{title: 'All tests passed', status: :passed, result: nil}],
                               status: :passed,
                               feedback: '',
                               expectation_results: [],
                               result: ''}
  end


  context 'answers a valid hash when submission fails' do
    let(:response) {bridge.run_tests!(test: %q{
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
};}, extra: '', content: %q{
class Foo {
  public:

  int foo() {
    return 5;
  }
};}, expectations: [])}

    it {expect(response).to eq response_type: :structured,
                               test_results: [{title: 'testFoo', status: :failed, result: Mumukit::ContentType::Markdown.code('assertion failed - Expression: foo->foo() == 4')}],
                               status: :failed,
                               feedback: '',
                               expectation_results: [],
                               result: ''}
  end
end
