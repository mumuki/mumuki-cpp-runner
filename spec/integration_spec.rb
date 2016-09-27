require 'active_support/all'
require 'mumukit/bridge'

describe 'Server' do
  let(:bridge) { Mumukit::Bridge::Runner.new('http://localhost:4568') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4568', err: '/dev/null'
    sleep 8
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission passes' do
    response = bridge.run_tests!(test: %q{
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
};}, expectations: [])

    expect(response[:result]).to include('OK')
    expect(response[:status]).to eq(:passed)
  end


  it 'answers a valid hash when submission fails' do
    response = bridge.run_tests!(test: %q{
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
};}, expectations: [])

    expect(response[:status]).to eq(:failed)
    expect(response[:result]).to include('Run:  1   Failures: 1   Errors: 0')
  end
end
