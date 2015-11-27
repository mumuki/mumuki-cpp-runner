class TestRunner < Mumukit::FileTestRunner
  include Mumukit::WithIsolatedEnvironment

  def post_process_file(file, result, status)
    if result.include? '!!TEST FINISHED WITH COMPILATION ERROR!!'
      [result, :errored]
    elsif result.include? '!!!FAILURES!!!'
      [result, :failed]
    else
      [result, :passed]
    end

  end

  def run_test_command(filename)
    "#{runcppunit_command} #{filename}"
  end

end