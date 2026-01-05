package {
  import flash.display.MovieClip;

  /**
   * Empty root for assets.swf.
   * Keeps the SWF safe to load as a library without showing anything.
   */
  public class AssetsRoot extends MovieClip {
    public function AssetsRoot() {
      stop();
    }
  }
}
