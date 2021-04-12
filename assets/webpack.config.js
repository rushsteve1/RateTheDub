const path = require("path");
const glob = require("glob");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = (env, options) => {
  const devMode = options.mode !== "production";

  return {
    optimization: {
      minimize: devMode ? undefined : true,
      minimizer: [new CssMinimizerPlugin()],
    },
    devtool: devMode ? "source-map" : undefined,
    entry: {
      app: glob.sync("./vendor/**/*.js").concat(["./js/app.js"]),
    },
    output: {
      filename: "[name].js",
      path: path.resolve(__dirname, "../priv/static/js"),
      publicPath: "/js/",
    },
    devtool: devMode ? "eval-cheap-module-source-map" : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
          },
        },
        {
          test: /\.css$/,
          use: [
            {
              loader: MiniCssExtractPlugin.loader,
              options: { publicPath: "/" },
            },
            "css-loader",
            "postcss-loader",
          ],
        },
      ],
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: "../css/app.css" }),
      new CopyWebpackPlugin({
        patterns: [{ from: "static/", to: "../" }],
      }),
    ],
  };
};
