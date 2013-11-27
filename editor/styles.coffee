define ["two/color"], (Color) ->
  styles = {}
  styles.SELECTION_COLOR =  new Color(r: 20, g: 0, b: 229)
  styles.SELECTION_FILL_COLOR = styles.SELECTION_COLOR.clone(a: 0.1)
  styles.LARGE_HANDLE_SIZE = 10
  styles.LARGE_HANDLE_PADDING = 12
  styles.SMALL_HANDLE_SIZE = styles.LARGE_HANDLE_SIZE / 2 + 2
  styles.SMALL_HANDLE_PADDING = styles.LARGE_HANDLE_PADDING - styles.SMALL_HANDLE_SIZE/2 + 2

  return styles

