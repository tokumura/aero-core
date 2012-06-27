xml.products(:type=>"array", :counts => @products.size.to_s) do
  @products.each do |product|
    xml.product() do
      xml.id(product.id, :type => "integer")
      xml.name(product.name)
      xml.price(product.price, :type => "integer")
      xml.classify(product.classify)
      xml.comment(product.comment)
      xml.photo(product.photo(:original), :size => "original")
      xml.photo(product.photo(:thumb), :size => "thumb")
      xml.departments(:type=>"array") do
        product.departments.each do |pd|
          xml.department() do
            department = Department.find(pd.department_id)
            xml.id(department.id)
            xml.name(department.name)
          end
        end
      end
      xml.categories(:type=>"array") do
        product.categories.each do |pc|
          xml.category() do
            category = Category.find(pc.category_id)
            xml.id(category.id)
            xml.name(category.name)
          end
        end
      end
    end
  end
end
