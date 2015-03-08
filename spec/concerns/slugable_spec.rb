shared_examples_for 'slugable' do
  let(:model) { described_class } # the class that includes the concern

  let(:title) { 'hello  world' }
  let(:slug) { 'hello-world' }
  let(:number) { '15-' }
  let(:chinese_title) { '习近平:中企承建港口电站等助斯里兰卡发展' }
  let(:chinese_slug) { 'xi-jin-ping-zhong-qi-cheng-jian-gang-kou-dian-zhan-deng-zhu-si-li-lan-qia-fa-zhan' }

  it 'returns a Slug for a title' do
    record = Fabricate(model.to_s.underscore.to_sym, title: title)
    expect(record.slug).to eq(slug)
  end

  it 'returns a symbolized slug for a chinese title' do
    record = Fabricate(model.to_s.underscore.to_sym, title: chinese_title)
    expect(record.slug).to eq(chinese_slug)
  end

  it 'returns model name when the slug is empty (say, numbers)' do
    record = Fabricate(model.to_s.underscore.to_sym, title: number)
    expect(record.slug).to eq(model.to_s.underscore)
  end

end
