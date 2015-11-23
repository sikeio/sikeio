var path = require("path");
var ExtractTextPlugin = require("extract-text-webpack-plugin");
module.exports = {
    // The standard entry point and output config
    entry: {
      static: "./assets/static.js",
    },
    output: {
      path: path.join(__dirname,"bundle"),
      // publicPath: "/assets/",
      filename: "[name].js",
    },
    module: {
        loaders: [
            // Extract css files
            {
                test: /\.css$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader")
            },

            {
                test: /\.scss$/,
                loader: ExtractTextPlugin.extract("style-loader", "css-loader!sass-loader")
            },

            {
                test: /\.jsx?$/,
                loader: "babel-loader?stage=0",
                exclude: /node_modules/,
            },
            // Optionally extract less files
            // or any other compile-to-css language
            // {
            //     test: /\.less$/,
            //     loader: ExtractTextPlugin.extract("style-loader", "css-loader!less-loader")
            // }
            // You could also use other loaders the same way. I. e. the autoprefixer-loader
        ]
    },

    // Use the plugin to specify the resulting filename (and add needed behavior to the compiler)
    plugins: [
        new ExtractTextPlugin("[name].css")
    ]
}