module BooksHelper
  def status_badge_class(status)
    base_class = "status-badge"
    modifier = status.to_s.parameterize

    "#{base_class} #{base_class}--#{modifier}"
  end
end
