guard 'bundler' do
  watch('Gemfile')
end

guard 'rspec', :cli => '--format documentation', :all_on_start => false, :all_after_pass => false do
  watch(%r{^spec/.+_spec.rb$})
  watch(%r{^app/(.+).rb$})              { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+).rb$})              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')          { "spec" }
  watch(%r{^spec/factories/(.+).rb$})   { "spec" }
end

guard 'livereload' do
  watch(%r{app/.+\.(erb|haml)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(public/|app/assets).+\.(css|js|html)})
  watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
  watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
  watch(%r{config/locales/.+\.yml})
end
