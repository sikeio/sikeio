module MarkdownHelper
  def render_markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true,
                              escape_html: true,
                              prettify: true)

    markdown = Redcarpet::Markdown.new(renderer,
                                       autolink: true,
                                       tables: true,
                                       no_intra_emphasis: true,
                                       strikethrough: true,
                                       fenced_code_blocks: true)

    markdown.render(text)
  end
end
