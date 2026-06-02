module ApplicationHelper
  def dictionary_color(dictionary_id)
    colors = %w[#e74c3c #e67e22 #f1c40f #2ecc71 #3498db #9b59b6 #1abc9c #e91e63 #ff5722 #607d8b]
    colors[(dictionary_id || 0) % 10]
  end
end
