require "bundler/setup"

require "tmpdir"
require "sinatra"

get '/' do
  git = params[:git]
  ref = params.fetch(:ref, "master")
  #path = params.fetch(:path, "")
  project_name = git.match(/([^\/]*)\.git$/)[1]
  tarball = ""

  Dir.mktmpdir() do |tmpdir|
    puts "git clone --bare #{git} #{tmpdir}"
    puts "cd #{tmpdir}"
    puts "git archive --format=tar --prefix=#{project_name}/ #{ref} | gzip > #{project_name}.tar.gz"
    output = %x{
      git clone --bare #{git} #{tmpdir}
      cd #{tmpdir}
      git archive --format=tar --prefix=#{project_name}/ #{ref} | gzip > #{project_name}.tar.gz
    }

    tarball = File.open("#{tmpdir}/#{project_name}.tar.gz", "rb") { |f| f.read }
  end
  attachment "#{project_name}.tar.gz"
  tarball
end
