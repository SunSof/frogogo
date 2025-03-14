products = Product.create([
  { name: 'Laptop', price: 999.99, description: 'High performance laptop' },
  { name: 'Smartphone', price: 599.99, description: 'Latest model smartphone' },
  { name: 'Headphones', price: 149.99, description: 'Noise-cancelling headphones' },
  { name: 'Keyboard', price: 79.99, description: 'Mechanical keyboard' },
  { name: 'Mouse', price: 29.99, description: 'Wireless mouse' }
])

image_path = Rails.root.join('app/assets/images/prod.png')

products.each do |product|
  file = File.open(image_path)
    
  product.image.attach(
    io: file,
    filename: 'prod.png',
    content_type: 'image/png'
  )
  file.close
end