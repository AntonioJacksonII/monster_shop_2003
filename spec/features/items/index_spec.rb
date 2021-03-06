require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items, merchant names, and images are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

        expect(page).to_not have_css("#item-#{@dog_bone.id}")
    end

    it "Visitors and Users can only view active items" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/items"

      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@pull_toy.name)
      expect(page).to_not have_content(@dog_bone.name)
    end
  end

  describe "visiting the items index page as any type of visitor" do

    it "I can see a section with item statistics" do
      user = User.create(name: "Fiona",
                         address: "123 Top Of The Tower",
                         city: "Duloc City",
                         state: "Duloc State",
                         zip: 10001,
                         email: "p.fiona12@castle.co",
                         password: "boom",
                         role: 0)

      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
      dragon = meg.items.create(name: "Dragon", description: "Guards your treasure as if it were its own.", price: 60, image: "https://images-na.ssl-images-amazon.com/images/I/51B9mwNncrL._AC_.jpg", inventory: 60)
      werewolf = meg.items.create(name: "Werewolf", description: "Knows when a full moon is on the rise.", price: 60, image: "https://ih1.redbubble.net/image.765064972.3394/throwpillow,small,750x600-bg,f8f8f8.jpg", inventory: 60)
      griffin = meg.items.create(name: "Griffin", description: "Will take you places.", price: 60, image: "https://m.media-amazon.com/images/I/91e1B5e8jIL._SR500,500_.jpg", inventory: 60)
      mermaid = meg.items.create(name: "Mermaid", description: "Be a mermaid from the comfort of your own home.", price: 60, image: "https://secure.img1-fg.wfcdn.com/im/59218715/resize-h800-w800%5Ecompr-r85/9053/90537369/Rosas+Kids+Mermaid+Tail+Blanket.jpg", inventory: 60)

      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 20)
      frankenstein = brian.items.create(name: "Frankenstein", description: "Great read!", price: 20, image: "https://i.ebayimg.com/images/g/4A8AAOSwj9RenuF5/s-l300.jpg", inventory: 20)
      cthulhu = brian.items.create(name: "Cthulhu", description: "Great gift!", price: 20, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQP11jyikd5WuCr4Ag4RK5uCn0NMoIee3IhkW3ZQV9w0-7MKSIA&usqp=CAU", inventory: 20)
      fairy = brian.items.create(name: "Fairy", description: "Sprinkle a little and spread your wings", price: 20, image: "https://i.etsystatic.com/6759919/r/il/806b42/1188540485/il_570xN.1188540485_fbhk.jpg", inventory: 20)

      order = Order.create(name: "Fiona", address: "123 Top Of The Tower", city: "Duloc City", state: "Duloc State", zip: 10001, user_id: user.id)

      ItemOrder.create(order_id: order.id, item_id: fairy.id, price: 50, quantity: 6)
      ItemOrder.create(order_id: order.id, item_id: tire.id, price: 50, quantity: 10)
      ItemOrder.create(order_id: order.id, item_id: werewolf.id, price: 50, quantity: 9)
      ItemOrder.create(order_id: order.id, item_id: cthulhu.id, price: 50, quantity: 7)
      ItemOrder.create(order_id: order.id, item_id: mermaid.id, price: 50, quantity: 8)
      ItemOrder.create(order_id: order.id, item_id: dog_bone.id, price: 50, quantity: 3)
      ItemOrder.create(order_id: order.id, item_id: griffin.id, price: 50, quantity: 4)
      ItemOrder.create(order_id: order.id, item_id: frankenstein.id, price: 50, quantity: 2)
      ItemOrder.create(order_id: order.id, item_id: pull_toy.id, price: 50, quantity: 1)
      ItemOrder.create(order_id: order.id, item_id: dragon.id, price: 50, quantity: 5)

      visit '/items'

      within "#top_five_items" do
        expect("Gatorskins: 10").to appear_before("Werewolf: 9")
        expect("Werewolf: 9").to appear_before("Mermaid: 8")
        expect("Mermaid: 8").to appear_before("Cthulhu: 7")
        expect("Cthulhu: 7").to appear_before("Fairy: 6")
        expect(page).to_not have_content("Pull Toy: 1")
      end

      within "#bottom_five_items" do
        expect("Pull Toy: 1").to appear_before("Frankenstein: 2")
        expect("Frankenstein: 2").to appear_before("Dog Bone: 3")
        expect("Dog Bone: 3").to appear_before("Griffin: 4")
        expect("Griffin: 4").to appear_before("Dragon: 5")
        expect(page).to_not have_content("Gatorskins: 10")
      end
    end
  end
end
