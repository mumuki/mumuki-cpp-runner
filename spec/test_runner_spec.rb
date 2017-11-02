require_relative 'spec_helper'

describe 'running' do
  let(:runner) {CppTestHook.new}

  def format_code(result)
    Mumukit::ContentType::Markdown.code result
  end

  describe '#run' do
    context 'on simple passed file' do
      let(:file) {File.new('spec/data/sample.cpp')}
      let(:results) {runner.run!(file)}

      it {expect(results[0]).to eq [['All tests passed', :passed]]}
    end


    context 'on simple failed file' do
      let(:file_failed) {File.new('spec/data/sample_failed.cpp')}
      let(:results) {runner.run!(file_failed)}

      it {expect(results[0]).to eq [['testFoo', :failed, format_code('assertion failed - Expression: foo->foo() == 4')]]}
    end

    context 'on simple compilation error file' do
      let(:file_compile_error) {File.new('spec/data/sample_compilation_error.cpp')}
      let(:results) {runner.run!(file_compile_error)}

      it {expect(results[1]).to eq :errored}
      it {expect(results[0]).to include "error: 'class Foo' has no member named 'foo'"}
    end


    context 'on multi file' do
      let(:file_multi) {File.new('spec/data/sample_multi.cpp')}
      let(:results) {runner.run!(file_multi)}

      it {expect(results[0].length).to eq 14}
      it {expect(results[0][0]).to eq ['test02', :failed, format_code('assertion failed - Expression: foo->foo() == 5 - HOLA')]}
      it {expect(results[0][1]).to eq ['test03', :failed, format_code('forced failure - FALLARIA')]}
      it {expect(results[0][2]).to eq ['test04', :failed, format_code('equality assertion failed - Expected: 5 - Actual  : 4')]}
      it {expect(results[0][3]).to eq ['test05', :failed, format_code('equality assertion failed - Expected: 5 - Actual  : 4 - Debería ser 4')]}
      it {expect(results[0][4]).to eq ['test06', :failed, format_code('double equality assertion failed - Expected: 1 - Actual  : 1.15 - Delta   : 0.14')]}
      it {expect(results[0][5]).to eq ['test07', :failed, format_code('double equality assertion failed - Expected: 1 - Actual  : 1.15 - Delta   : 0.14 - Deberia haber un delta de 0.15 aceptable')]}
      it {expect(results[0][6]).to eq ['test08', :failed, format_code('expected exception not thrown - Expected: CppUnit::Exception')]}
      it {expect(results[0][7]).to eq ['test09', :failed, format_code('expected exception not thrown - DEBERIA FALLAR - Expected: CppUnit::Exception')]}
      it {expect(results[0][8]).to eq ['test10', :failed, format_code('unexpected exception caught - Caught: std::out_of_range - What(): vector::_M_range_check: __n (which is 50) >= this->size() (which is 0)')]}
      it {expect(results[0][9]).to eq ['test11', :failed, format_code('unexpected exception caught - DEBERIA FALLAR - Caught: std::out_of_range - What(): vector::_M_range_check: __n (which is 50) >= this->size() (which is 0)')]}
      it {expect(results[0][10]).to eq ['test12', :failed, format_code('expected exception not thrown - Expected: CppUnit::Exception')]}
      it {expect(results[0][11]).to eq ['test13', :failed, format_code('expected exception not thrown - No deberían ser iguales - Expected: CppUnit::Exception')]}
      it {expect(results[0][12]).to eq ['test14', :failed, format_code('unexpected exception caught - Caught: std::out_of_range - What(): vector::_M_range_check: __n (which is 50) >= this->size() (which is 0)')]}
      it {expect(results[0][13]).to eq ['test15', :failed, format_code('unexpected exception caught - DEBERIA FALLAR - Caught: std::out_of_range - What(): vector::_M_range_check: __n (which is 50) >= this->size() (which is 0)')]}
    end

  end
end



