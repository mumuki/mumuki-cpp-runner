class CppMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'c++',
        icon: {type: 'devicon', name: 'cpp'},
        extension: 'cpp',
        ace_mode: 'c_cpp'
    },
     test_framework: {
         name: 'cppunit',
         test_extension: 'cpp'
     }}
  end
end