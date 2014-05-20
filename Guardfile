guard 'rspec', version: 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})          {|m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
  watch('spec/spec_helper.rb')       { "spec" }
end

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard 'shell' do
  watch(/(.*).txt/) {|m| `tail #{m[0]}` }
end
