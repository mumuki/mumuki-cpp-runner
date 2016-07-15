class CppMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'c++',
        icon: {type: 'devicon', name: 'c'},
        extension: 'cpp',
        ace_mode: 'c_cpp'
    },
     test_framework: {
         name: 'cppunit',
         test_extension: 'cpp'
     }}
  end
end