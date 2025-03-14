products = Product.create([
  { name: 'Беспроводная колонка Goodyear Bluetooth Speaker', price: 1600.00, description: 'ABC' },
  { name: 'Женский домашний костюм Sweet Dreams', price: 800.00, description: 'ABC' },
  { name: 'Плащ-дождевик SwissOak', price: 400.00, description: 'ABC' },
])

image_paths = [
  Rails.root.join('app/assets/images/prod.png'),
  Rails.root.join('app/assets/images/prod2.png'),
  Rails.root.join('app/assets/images/prod3.png')
]

products.each_with_index do |product, index|
  path = image_paths[index]
  file = File.open(path)
  product.image.attach(
      io: file,
      filename: File.basename(path),
      content_type: 'image/png'
    )
  file.close
end