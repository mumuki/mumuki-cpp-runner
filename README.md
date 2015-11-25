[![Stories in Ready](https://badge.waffle.io/mumuki/mumuki-cppunit-server.png?label=ready&title=Ready)](https://waffle.io/mumuki/mumuki-cppunit-server)
[![Build Status](https://travis-ci.org/mumuki/mumuki-cppunit-server.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-cppunit-server)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-cppunit-server/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-cppunit-server)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-cppunit-server/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-cppunit-server)

> mumuki-cppunit-server

# Before install

```
sudo apt-get install g++ libcppunit-dev
```

# Run the server

```
RACK_ENV=development rackup -p 4567
```

# Using the runner

## Writing a test

See [Cpp Documentation](http://cppunit.sourceforgeu.net/doc/cvs/cppunit_cookbook.html)

This runner does the following for you:
  * adds cpp's requires
  * writes the main method for you

In exchange, you must name you CppUnit `MumukiTest` and expose a `testSuite()` static method - which should be defined using `CPP_UNIT_TEST` macros -. Example: 

```C++
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
```







