# 在 _plugins 目录下创建此文件
require 'json'

module Jekyll
  class SearchIndexGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # 准备搜索数据
      data = {
        documents: {}
      }

      # 处理所有文章
      site.posts.docs.each do |post|
        data[:documents][post.url] = {
          title: post.data['title'],
          url: post.url,
          date: post.date.strftime('%Y-%m-%d'),
          category: post.data['category'],
          tags: post.data['tags'] || [],
          content: post.content.gsub(/<\/?[^>]*>/, '').gsub(/\s+/, ' ').strip
        }
      end

      # 创建输出目录
      FileUtils.mkdir_p(site.dest + '/assets/js')

      # 写入搜索索引文件
      File.open(site.dest + '/assets/js/search-index.json', 'w') do |f|
        f.write(data.to_json)
      end
    end
  end
end
