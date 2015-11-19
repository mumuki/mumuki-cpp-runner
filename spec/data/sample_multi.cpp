#include <cppunit/ui/text/TestRunner.h>
#include <cppunit/extensions/HelperMacros.h>

class Foo {
  public:

  int foo() {
    return 4;
  }
};

class MumukiTest : public CppUnit::TestFixture  {
  CPPUNIT_TEST_SUITE( MumukiTest );
    CPPUNIT_TEST( testFoo );
    CPPUNIT_TEST( testBar );

  CPPUNIT_TEST_SUITE_END();

  void testFoo()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT( foo->foo() == 4 );
    delete foo;
  }

  void testFoo()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT( foo->foo() == 5 );
    delete foo;
  }
};

int main( int argc, char **argv)
{
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( MumukiTest::suite() );
  runner.run();
  return 0;
}