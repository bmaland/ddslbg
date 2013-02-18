RSpec.configure do |config|
  # Annotate specs with focus: true for focused runs
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end
