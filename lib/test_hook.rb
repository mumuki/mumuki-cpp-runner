class CppTestHook < Mumukit::Templates::FileHook
  mashup
  isolated true

  def tempfile_extension
    '.cpp'
  end

  def command_line(filename)
    "runcppunit #{filename}"
  end

  def post_process_file(file, result, status)
    if result.include? '!!TEST FINISHED WITH COMPILATION ERROR!!'
      [result, :errored]
    elsif result.include? '!!!FAILURES!!!'
      [result, :failed]
    else
      [result, :passed]
    end
  end

  def compile_file_content(request)
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
