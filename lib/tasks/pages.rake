namespace :pages do

  desc 'Update pages from seed'
  task update: [:environment] do
    pages_to_replace = ['tos', 'privacy']
    Page.where(slug: pages_to_replace).each &:destroy
    Rake::Task["db:seed:pages"].invoke
  end

end
