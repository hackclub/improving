class GalleryController <  ApplicationController
  def index
    # You can add logic here if needed
    @projects = Project.where.not(dont_show_public: true)
  end
end