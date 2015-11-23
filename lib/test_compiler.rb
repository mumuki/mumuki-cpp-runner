class TestCompiler < Mumukit::MashupTestCompiler
  def tempfile_extension
    '.cpp'
  end

  def compile(request)
    <<EOF
#include <cppunit/ui/text/TestRunner.h>
#include <cppunit/extensions/HelperMacros.h>

#{super}
int main( int argc, char **argv)
{
  CppUnit::TextUi::TestRunner runner;
  runner.addTest( MumukiTest::suite() );
  runner.run();
  return 0;
}
EOF
  end
end
