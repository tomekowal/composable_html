defmodule ComposableHtml.Tag do
  defstruct [:tag_name, :content, :attrs]
  alias ComposableHtml.Tag
  alias Phoenix.HTML.Tag, as: PhoenixTag

  def new(tag_name, content \\ nil, attrs \\ []) when is_atom(tag_name) do
    %Tag{tag_name: tag_name, content: content, attrs: attrs}
  end

  def to_phoenix_html(%Tag{} = tag) do
    phoenix_attrs = Enum.intersperse(tag.attrs, ?\s)

    if tag.content do
      PhoenixTag.content_tag(tag.tag_name, to_phoenix_html(tag.content), phoenix_attrs)
    else
      PhoenixTag.tag(tag.tag_name, phoenix_attrs)
    end
  end

  def to_phoenix_html(list_of_tags) when is_list(list_of_tags) do
    Enum.map(list_of_tags, &to_phoenix_html/1)
  end

  # The data will be used in the `content_tag` so it doesn't have to be escaped here
  def to_phoenix_html(data), do: data
end

defimpl Phoenix.HTML.Safe, for: ComposableHtml.Tag do
  alias ComposableHtml.Tag

  def to_iodata(data) do
    {:safe, data} = Tag.to_phoenix_html(data)
    data
  end
end
