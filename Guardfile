# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :growl
guard 'coffeescript', input: 'editor', output: 'build', all_on_start: true do
  watch(%r{spec/(.+\.coffee)})
end
guard 'sass', :input => 'editor', :output => 'build', all_on_start: true
