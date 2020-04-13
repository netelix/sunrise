def only_for_desktop
  return unless device[:name] == :chrome_desktop

  yield
end

def only_for_mobile
  return unless device[:name] == :chrome_android_phone

  yield
end