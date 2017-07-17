#include <cppunit/ui/text/TestRunner.h>
#include <cppunit/extensions/HelperMacros.h>

#include <iostream>

class Foo {
  public:

  int foo() {
    return 4;
  }
};

class MumukiTest : public CppUnit::TestFixture  {
  CPPUNIT_TEST_SUITE( MumukiTest );
    CPPUNIT_TEST( test01 );
    CPPUNIT_TEST( test02 );
    CPPUNIT_TEST( test03 );
    CPPUNIT_TEST( test04 );
    CPPUNIT_TEST( test05 );
    CPPUNIT_TEST( test06 );
    CPPUNIT_TEST( test07 );
    CPPUNIT_TEST( test08 );
    CPPUNIT_TEST( test09 );
    CPPUNIT_TEST( test10 );
    CPPUNIT_TEST( test11 );
    CPPUNIT_TEST( test12 );
    CPPUNIT_TEST( test13 );
    CPPUNIT_TEST( test14 );
    CPPUNIT_TEST( test15 );
  CPPUNIT_TEST_SUITE_END();

  void test01()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT( foo->foo() == 4 );
    delete foo;
  }

  void test02()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT_MESSAGE( "HOLA", foo->foo() == 5 );
    delete foo;
  }

  void test03()
  {
    Foo* foo = new Foo();
    CPPUNIT_FAIL( "FALLARIA" );
    delete foo;
  }

  void test04()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT_EQUAL( 5, foo->foo() );
    delete foo;
  }

  void test05()
  {
    Foo* foo = new Foo();
    CPPUNIT_ASSERT_EQUAL_MESSAGE("Debería ser 4", 5, foo->foo() );
    delete foo;
  }

  void test06()
  {
    CPPUNIT_ASSERT_DOUBLES_EQUAL(1.00, 1.15, 0.14);
  }

  void test07()
  {
    CPPUNIT_ASSERT_DOUBLES_EQUAL_MESSAGE("Deberia haber un delta de 0.15 aceptable", 1.00, 1.15, 0.14);
  }

  void test08()
  {
    CPPUNIT_ASSERT_THROW( 13, CPPUNIT_NS::Exception);
  }

  void test09()
  {
    CPPUNIT_ASSERT_THROW_MESSAGE("DEBERIA FALLAR", 13, CPPUNIT_NS::Exception);
  }

  void test10()
  {
    std::vector<int> v;
    CPPUNIT_ASSERT_NO_THROW(v.at( 50 ));
  }

  void test11()
  {
    std::vector<int> v;
    CPPUNIT_ASSERT_NO_THROW_MESSAGE("DEBERIA FALLAR", v.at( 50 ));
  }

  void test12()
  {
    CPPUNIT_ASSERT_ASSERTION_FAIL(1 == 1);
  }

  void test13()
  {
    CPPUNIT_ASSERT_ASSERTION_FAIL_MESSAGE("No deberían ser iguales", 1 == 1);
  }

  void test14()
  {
    std::vector<int> v;
    CPPUNIT_ASSERT_ASSERTION_PASS(v.at( 50 ));
  }

  void test15()
  {
    std::vector<int> v;
    CPPUNIT_ASSERT_ASSERTION_PASS_MESSAGE("DEBERIA FALLAR", v.at( 50 ));
  }

};

int main( int argc, char **argv)
{
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( MumukiTest::suite() );
  runner.run();
  return 0;
}
