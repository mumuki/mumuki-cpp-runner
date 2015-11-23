require_relative './spec_helper'


class File
  def unlink
  end
end


describe TestRunner do
  let(:runner) { TestRunner.new('gpp_command' => 'g++') }
  let(:file) { File.new('spec/data/sample.cpp') }
  let(:file_multi) { File.new('spec/data/sample_multi.cpp') }
  let(:file_failed) { File.new('spec/data/sample_failed.cpp') }
  let(:file_compile_error) { File.new('spec/data/sample_compilation_error.cpp') }

  describe '#run_compilation!' do
    context 'on simple passed file' do
      let(:results) { runner.run_compilation!(file) }

      it { expect(results).to eq([".\n\n\nOK (1 tests)\n\n\n", :passed]) }
    end

    context 'on simple failed file' do
      let(:results) { runner.run_compilation!(file_failed) }

      it { expect(results[1]).to eq :failed }
      it { expect(results[0]).to include 'Run:  1   Failures: 1   Errors: 0' }
    end

    context 'on simple compilation error file' do
      let(:results) { runner.run_compilation!(file_compile_error) }

      it { expect(results[1]).to eq :errored }
      it { expect(results[0]).to include 'error: ‘class Foo’ has no member named ‘foo’' }
    end


    context 'on multi file' do
      let(:results) { runner.run_compilation!(file_multi) }

      it { expect(results[0]).to include 'Run:  2   Failures: 1   Errors: 0' }
      it { expect(results[1]).to eq :failed }
    end
  end
end
