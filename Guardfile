guard 'rspec', all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/ddslbg/(.+)\.rb$})   { |m| "spec/ddslbg/#{m[1]}_spec.rb" }
  watch('lib/ddslbg.rb')             { 'spec' }
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('spec/spec_helper.rb')       { 'spec' }
end
