class CppTestHook < Mumukit::Templates::FileHook
  mashup
  isolated true
  structured true

  def tempfile_extension
    '.cpp'
  end

  def command_line(filename)
    "runcppunit #{filename}"
  end

  def post_process_file(file, result, status)
    if result.include? '!!TEST FINISHED WITH COMPILATION ERROR!!'
      [Mumukit::ContentType::Markdown.code(result), :errored]
    else
      super
    end
  end

  def to_structured_result(result)
    if result.include? '!!!FAILURES!!!'
      transform(result)
    else
      [['All tests passed', :passed]]
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

  private

  def transform(result)
    result
        .split(/\d{0,9}\) test: MumukiTest::/)
        .drop(1)
        .map do |it|
      captures = it.split("\n")
      title = captures.first.split(' (F)').first
      result = [captures[1], captures[2], captures[3], captures[4], captures[5]].compact.join(' ').strip
      [title, :failed, result]
    end
  end

end
