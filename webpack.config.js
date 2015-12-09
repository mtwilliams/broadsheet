var webpack = require("webpack");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

var node_dir = __dirname + '/node_modules';

module.exports = [
  {
    context: __dirname + "/spa",
    name: "broadsheet",
    entry: "./broadsheet.coffee",
    plugins: [
      new webpack.DefinePlugin({
        ENV: JSON.stringify("broadsheet")
      }),
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        "window.jQuery": "jquery"
      }),
      new ExtractTextPlugin("bundle.css", {
        allChunks: true
      })
    ],
    resolve: {
      alias: {
        'normalize': node_dir + '/normalize.css/normalize.css',
        'jquery': node_dir + '/jquery/dist/jquery.js',
        'vue': node_dir + '/vue/dist/vue.common.js',
        'vue-router': node_dir + '/vue-router/dist/vue-router.common.js',
      }
    },
    output: {
      path: __dirname + "/public/assets/",
      publicPath: "/assets/",
      filename: "bundle.js",
    },
    module: {
      loaders: [
        {
          test: /\.html$/,
          loader: "html-loader"
        },

        {
          test: /\.js$/,
          exclude: /(node_modules|bower_components)/,
          loader: "script-loader"
        },

        {
          test: /\.coffee$/,
          exclude: /(node_modules|bower_components)/,
          loader: "coffee-loader"
        },

        {
          test: /\.scss$/,
          exclude: /(node_modules|bower_components)/,
          loader: ExtractTextPlugin.extract("css!sass")
        },

        {
          test: /\.(jpe?g|png|gif|svg)$/i,
          // loader: "url-loader?limit=8192"
          loader: "file?name=[path][name].[ext]?[sha1:hash]"
        }
      ]
    },
    devtool: "#inline-source-map"
  }
];
