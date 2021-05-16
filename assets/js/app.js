// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
// import "phoenix_html";

// Import Swup and its plugins which will be used to preload pages on hover and
// to perform page transitions.
// This gives RateTheDub an extremely snappy feeling while remaining entirely
// server-side rendered and with full no-JS support.
import Swup from "swup";
import SwupFormsPlugin from "@swup/forms-plugin";
import SwupHeadPlugin from "@swup/head-plugin";
import SwupPreloadPlugin from "@swup/preload-plugin";
import SwupProgressPlugin from "@swup/progress-plugin";

const swup = new Swup({
  animationSelector: "[class*='swup-transition-']",
  plugins: [
    new SwupFormsPlugin(),
    new SwupHeadPlugin({
      persistAssets: true,
      persistTags: "link[rel=stylesheet], link[rel=icon], script[src]",
    }),
    new SwupPreloadPlugin(),
    new SwupProgressPlugin({ delay: 500 }),
  ],
});
