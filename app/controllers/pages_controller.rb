class LSPost
  attr_accessor :id, :first_name, :last_name, :school, :dsc, :img

  def initialize(attributes = {})
    assign_attributes(attributes)
  end

  def assign_attributes(values)
    values.each do |k, v|
      send("#{k}=", v)
    end
  end
end

class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def show_slug
    slug = params[:slug].to_s
    @page = Page.find_by(slug: slug)
    render slug if template_exists?(slug, 'pages')
  end

  def dummy_ls_posts
    ls_posts = []
    8.times do |i|
      ls_posts << LSPost.new(id: i,
                             first_name: "First_#{i}",
                             last_name: "Last_#{i}",
                             school: "School_#{i}",
                             dsc: Faker::Lorem.sentence(rand(4..18)),
                             img: 'https://unbounded-uploads-development.s3.amazonaws.com/content_guides/3/CG%2B-%2BMath%2BK-2%2B-%2B1.05x1-min.jpg')
    end
    ls_posts
  end

  def leadership
    @ls_posts = dummy_ls_posts
  end
end
