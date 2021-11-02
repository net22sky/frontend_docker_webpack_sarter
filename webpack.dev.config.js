const path = require('path');
const miniCss = require('mini-css-extract-plugin');
const webpack = require('webpack');
const minify = require('optimize-css-assets-webpack-plugin');
const DashboardPlugin = require('webpack-dashboard/plugin');
const autoprefixer = require('autoprefixer');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const OptimaizeCssAccetPlugin = require('optimize-css-assets-webpack-plugin');
const TerserWebpackPlugin = require('terser-webpack-plugin');
const  {CleanWebpackPlugin}  = require('clean-webpack-plugin');
const ImageminPlugin = require('imagemin-webpack-plugin')
const TerserPlugin = require('terser-webpack-plugin');
const LiveReloadPlugin = require('webpack-livereload-plugin');
const CopyPlugin = require("copy-webpack-plugin");

 
module.exports = {
    externals: {
        jquery: 'jQuery'
      },
	mode: 'development',
	entry: './src/index.js',
	output: {
		path: path.resolve(__dirname, 'app/dist/'),
		filename: 'scripts.js'
    },
    resolve: {
        alias: {
          vue: 'vue/dist/vue.js'
        }
      },
	module: {
		rules: [{
            test:/\.(s*)js$/,
            loader: 'babel-loader',
            exclude: '/node_modules/'
            },
            /*test: /\.vue$/,
            loader: 'vue-loader',
            options: {
                loader: {
                scss: 'vue-style-loader!css-loader!sass-loader'
                }
            },*/
            {
			//test:/\.(s*)css$/,
                test: /\.scss$/,
			/*use: [
				miniCss.loader,
                'css-loader',
                'postcss-loader',
				'sass-loader',
            ]*/
            use: [
                miniCss.loader,
                {
                    loader: 'css-loader',
                    options: {
                        sourceMap: true
                    }
                },
                {
                    loader: 'postcss-loader',
                    options: {
                        sourceMap: true,
                        config: {
                            path: 'src/postcss.config.js'
                        }
                    }
                },
                {
                    loader: 'sass-loader',
                    options: {
                        sourceMap: true
                    }
                    
                }
            ],
                include: path.join(__dirname, 'src'),
            },
        {
            test: /\.(woff(2)?|ttf|eot)(\?v=\d+\.\d+\.\d+)?$/,
            use: [
              {
                loader: 'file-loader',
                options: {
                  name: '[name].[ext]',
                  outputPath: 'fonts'
                }
              }
            ]
          },
          /*{
            test: /\.svg$/,
            loader: 'svg-inline-loader',
           },*/
          {
            test: /\.(png|jpe?g|gif|svg)$/i,
            loader: 'file-loader',
            options: {
                name: '[path][name].[ext]',
                outputPath: 'images',
            },
          }

    ]
	},
	optimization: {
		minimizer: [
            /*new UglifyJsPlugin({
                test: /\.js(\?.*)?$/i,
                extractComments: true,
              }),

             */
            new TerserPlugin({
                test: /\.js(\?.*)?$/i,
                extractComments: true,
                sourceMap: true,
            }),
			new minify({})
        ],
        splitChunks: {
            // include all types of chunks
            chunks: 'all'
          },
	},
	plugins: [
        //new DashboardPlugin(),
        //new CleanWebpackPlugin(   ),
        new webpack.SourceMapDevToolPlugin({
            filename: '[file].map'
        }),
		new miniCss({
			filename: '../dist/main.css',
        }),
        new webpack.ProvidePlugin({
            $: "jquery/dist/jquery.min.js",
            jQuery: "jquery/dist/jquery.min.js",
            "window.jQuery": "jquery/dist/jquery.min.js"
          }),
        new LiveReloadPlugin(),
        new  CleanWebpackPlugin ( ),
        new CopyPlugin({
            patterns: [
              { 
                from: "images/*.*",
                },
            ],
          }),
    ]
};



            

