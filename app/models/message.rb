class Message < ActiveRecord::Base
  def distance(mylatitude, mylongitude)
      Math.sqrt((mylatitude - latitude).abs ** 2 + (mylongitude - longitude).abs ** 2)
  end
end
