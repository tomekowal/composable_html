defmodule ComposableHtml do
  alias ComposableHtml.Tag

  @moduledoc """
  Documentation for ComposableHtml.
  """

  @doc """
  Creates composable tag.
  Tag content can be either another tag, a list of tags or other data
  handled by Phoenix.HTML.Safe.

  ## Examples

      iex> ComposableHtml.tag(:td)
      %ComposableHtml.Tag{tag_name: :td, content: nil, attrs: []}

  """
  defdelegate tag(tag_name, content \\ nil, attrs \\ []), to: Tag, as: :new

  def with_content(%Tag{} = tag, content) do
    %Tag{tag | content: content}
  end

  def with_attrs(%Tag{} = tag, attrs) do
    %Tag{tag | attrs: attrs}
  end

  def remove_attr(%Tag{} = tag, attr_name) do
    %Tag{tag | attrs: Keyword.delete(tag.attrs, attr_name)}
  end

  def add_attr(%Tag{} = tag, attr_name) do
    %Tag{tag | attrs: Keyword.put(tag.attrs, attr_name, [])}
  end

  def add_attr_value(%Tag{} = tag, attr_name, attr_value) when is_atom(attr_name) do
    %Tag{tag | attrs: Keyword.update(tag.attrs, attr_name, [attr_value], &[attr_value | &1])}
  end

  def remove_attr_value(%Tag{} = tag, attr_name, attr_value) when is_atom(attr_name) do
    %Tag{tag | attrs: Keyword.update(tag.attrs, attr_name, [], &List.delete(&1, attr_value))}
  end

  def add_class(%Tag{} = tag, class) do
    add_attr_value(tag, :class, class)
  end

  def remove_class(%Tag{} = tag, class) do
    remove_attr_value(tag, :class, class)
  end

  def wrap_content_with_tag(content, %Tag{} = tag) do
    %Tag{tag | content: content}
  end
end
