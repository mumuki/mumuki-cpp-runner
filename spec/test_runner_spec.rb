require_relative 'spec_helper'

describe 'running' do
  let(:runner) { CppTestHook.new }


  describe '#run' do
    context 'on simple passed file' do
      let(:file) { File.new('spec/data/sample.cpp') }
      let(:results) { runner.run!(file) }

      it { expect(results).to eq([".\n\n\nOK (1 tests)\n\n\n", :passed]) }
    end


    context 'on simple failed file' do
      let(:file_failed) { File.new('spec/data/sample_failed.cpp') }
      let(:results) { runner.run!(file_failed) }

      it { expect(results[1]).to eq :failed }
      it { expect(results[0]).to include 'Run:  1   Failures: 1   Errors: 0' }
    end

    context 'on simple compilation error file' do
      let(:file_compile_error) { File.new('spec/data/sample_compilation_error.cpp') }
      let(:results) { runner.run!(file_compile_error) }

      it { expect(results[1]).to eq :errored }
      it { expect(results[0]).to include "error: 'class Foo' has no member named 'foo'" }
    end


    context 'on multi file' do
      let(:file_multi) { File.new('spec/data/sample_multi.cpp') }
      let(:results) { runner.run!(file_multi) }

      it { expect(results[0]).to include 'Run:  2   Failures: 1   Errors: 0' }
      it { expect(results[1]).to eq :failed }
    end

  end
end



