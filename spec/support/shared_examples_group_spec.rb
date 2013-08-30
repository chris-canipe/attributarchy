shared_examples_for 'an attributarchy' do
  it 'should be wrapped in an attributarchy-classed div' do
    expect(output).to start_with('<div class="attributarchy">')
    expect(output).to end_with('</div>')
  end
end
