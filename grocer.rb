require 'byebug'
require 'pry'

def consolidate_cart(cart)
  item_hash = {}
  cart.each do |element|
    element.each do |item, data|
      item_hash[item] = data
      if item_hash[item][:count]
        item_hash[item][:count] += 1
      else
        item_hash[item][:count] = 1
      end
    end
  end
  return item_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name] && cart[name][:count] >= coupon[:num]
      if cart["#{name} W/COUPON"]
        cart["#{name} W/COUPON"][:count] += 1
      else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
      end
      cart[name][:count] = cart[name][:count] - coupon[:num]
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance]
      data[:price] *= 0.80
      data[:price] = data[:price].round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  clearanced = apply_clearance(couponed)
  total = 0
  clearanced.each do |item, data|
    item_total = data[:price] * data[:count]
    total += item_total
  end
  if total > 100
    total *= 0.90
  end
  return total
end
