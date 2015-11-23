require 'tempfile'

class TestRunner < Mumukit::FileTestRunner

  def run_test_file!(test_file)
    executable_file = Tempfile.new('mumuki.cppunit.test')
    compilation_output, compilation_status = compile_executable(executable_file, test_file)
    executable_file.close

    return [compilation_output, :errored] if compilation_status == :errored

    run_executable(executable_file)
  end

  def compile_executable(executable_file, test_file)
    compilation_output, compilation_status = [
        %x{#{compile_test_file_command(test_file.path, executable_file.path)}},
        $?.success? ? :passed : :errored
    ]
    return compilation_output, compilation_status
  end

  def run_executable(output_file)
    out = %x{#{output_file.path}}
    [out, $?.success? && !out.include?('!!!FAILURES!!!') ? :passed : :failed]
  end

  def compile_test_file_command(test_file, output_file)
    "#{gpp_command} #{test_file} -o #{output_file} -lcppunit 2>&1"
  end

end
