import { addons } from '@storybook/addons';

addons.setConfig({
  isToolshown: false,
  webpackFinal: async (config, { configType }) => {
    // `configType` has a value of 'DEVELOPMENT' or 'PRODUCTION'
    // You can change the configuration based on that.
    // 'PRODUCTION' is used when building the static version of storybook.

    // Make whatever fine-grained changes you need
    config.module.rules.push({ test: /\.(png|css|woff|woff2|eot|ttf|svg)$/, loader: 'url-loader?limit=100000' });
    // Return the altered config
    return config;
  },
});
