# Welcome

Hi! Thanks for thinking about contributing to this project! Feel free to open
issues, pull requests and create forks. 

# Issues

Issues are meant for tracking suggestions and problems with this project. If
something doesn't behave the way it seems it should then that's a bug. If you
think this project could be improved then that's a suggestion. If you think
everything is working fine, but can't figure out how to do it then that might
be a documentation issue.

## Bugs

Some of the bugs you encounter with included software might be caused by this
project. Please open an issue here if you think that might be the case. You 
should open an issue when a piece of software
is missing even though it is said to be included in the README or when it is
more broken than ususal, e.g. it crashes in the image when it doesn't on your
machine. Build issues and spelling errors are also bugs.

When opening an issue please be as specific as possible. Clearly state what
you expect to be happening and what is actually happening. State how you can
produce the bug as accurately as possible. If the issue occurs within the image
please provide the exact commands you entered. This will make it easier to test
when the problem was introduced and if it was fixed.

## Suggestions

If you have found a way to make this project better, please make sure to
clearly explain what it is you are asking for and why it should be included
by default in all future versions. 

## Documentation Issue

If you don't understand how to do something then that might also be an issue.
However, the issue tracker is not a tech support forum so there are some rules:

- You must have read the relevant parts of the documentation before opening
the issue.
- The issue must not be just about the usage of a specific piece of software
included in the image. There are widely available guides for `apt-get`, `bash`
and so on. An exception is the README which provides a quick-start guide for
`docker`.

Once your issue is opened, a maintainer will make sure to amend the
documentation with the info you need.

# Pull Requests

Thank you for wanting to invest your time into making this project better. The
requirements for pull requests aren't very high: 

- If you are doing more than fixing a simple spelling error, it would be nice
of you to open an issue for it and reference it in your PR. This helps separate
discussion of the solution (Pull Request) from that of the problem (Issue).
- Make sure that your changes pass the tests. Once you have opened a PR,
TravisCI will automatically run a bunch of tests to make sure that your changes
haven't broken anything. Your changes can't be merged if they don't work.
- Try to make your commit messages descriptive. It's sometimes useful to know
why a change was made and commits are an important tool for that.
- Don't introduce closed-source software.

# Forking

If you want to fork this project for more than pull requests there are a few
things to note:
- `imagefs/motd.3ds-dev` mentions my releases page. You are responsible for
providing the sources, so please change that.
- The `.travis.yml` file is setup to push releases to my docker account.
If you want your releases to work you need to change that.