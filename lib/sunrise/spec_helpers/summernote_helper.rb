def fill_summernote_with_text(path, text)
  find(path).set(' ')
  find(path).send_keys(text)
end

def fill_summernote_with_html(path, html)
  wait_for_ajax
  evaluate_script("$('#{path}').parent().find('.note-editable').html(' ')")
  evaluate_script(
    "$('#{path}').summernote('editor.pasteHTML', '#{html.delete("\n")}')"
  )
end
