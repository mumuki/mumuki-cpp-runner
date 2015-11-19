require_relative './spec_helper'

describe TestCompiler do
  true_test = <<CPP
class MumukiTest : public CppUnit::TestFixture {
  CPPUNIT_TEST_SUITE( MumukiTest );
    CPPUNIT_TEST( testTrueIsTrue );
  CPPUNIT_TEST_SUITE_END();

  void testTrueIsTrue()
  {
    CPPUNIT_ASSERT( true == true  );
  }
};
CPP

  true_submission = <<EOT
_true = 1;
EOT

  compiled_test_submission = <<EOT
#include <cppunit/ui/text/TestRunner.h>
#include <cppunit/extensions/HelperMacros.h>

class Bar {};
class Foo {};

class MumukiTest : public CppUnit::TestFixture {
  CPPUNIT_TEST_SUITE( MumukiTest );
    CPPUNIT_TEST( testTrueIsTrue );
  CPPUNIT_TEST_SUITE_END();

  void testTrueIsTrue()
  {
    CPPUNIT_ASSERT( true == true  );
  }
};

int main( int argc, char **argv)
{
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( MumukiTest::suite() );
  runner.run();
  return 0;
}
EOT

  describe '#compile' do
    let(:compiler) { TestCompiler.new(nil) }
    let(:request) { OpenStruct.new(test: true_test, extra: 'class Bar {};', content: 'class Foo {};') }
    it { expect(compiler.compile(request)).to eq(compiled_test_submission) }
  end

end
