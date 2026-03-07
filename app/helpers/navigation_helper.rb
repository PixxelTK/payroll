module NavigationHelper
  def nav_link(name, path)
    active =
      if path == root_path
        request.path == root_path
      else
        request.path.start_with?(path)
      end

    css = if active
      "block px-3 py-2 rounded bg-sky-500 text-white dark:bg-zinc-700"
    else
      "block px-3 py-2 rounded hover:bg-zinc-400 text-slate-600 dark:text-slate-200 dark:hover:bg-zinc-800"
    end

    link_to name, path,
      class: css,
      data: { turbo_frame: "content", turbo_action: "advance" }
  end
end
