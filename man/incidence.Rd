% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/incidence.R
\name{incidence}
\alias{incidence}
\title{Compute the incidence of events}
\usage{
incidence(
  x,
  date_index,
  groups = NULL,
  interval = 1L,
  na_as_group = TRUE,
  counts = NULL,
  firstdate = NULL
)
}
\arguments{
\item{x}{A data frame representing a linelist (or potentially a
pre-aggregated dataset).}

\item{date_index}{The time index(es) of the given data.  This should be the
name(s) corresponding to the desired date column(s) in x of class:
integer, numeric, Date, POSIXct, POSIXlt, and character. (See Note  about
\code{numeric} and \code{character} formats). Multiple inputs only make sense when
x is a linelist, and in this situation, to avoid ambiguity, the vector must
be named.  These names will be used for the resultant count columns.}

\item{groups}{An optional vector giving the names of the groups of
observations for which incidence should be grouped.}

\item{interval}{An integer or character indicating the (fixed) size of the
time interval used for computing the incidence; defaults to 1 day. This can
also be a text string that corresponds to a valid date interval, e.g.\preformatted{* (x) day(s)
* (x) weeks(s)
* (x) epiweeks(s)
* (x) isoweeks(s)
* (x) months(s)
* (x) quarter(s)
* (x) years(s)
}

More details can be found in the "Interval specification" and "Week
intervals" sections below.}

\item{na_as_group}{A logical value indicating if missing group values (NA)
should treated as a separate category (\code{TRUE}) or removed from
consideration (\code{FALSE}). Defaults to \code{TRUE}.}

\item{counts}{The count variables of the given data.  If NULL (default) the
data is taken to be a linelist of individual observations.}

\item{firstdate}{When the interval is numeric or in days/months and has a
numeric prefix greater than 1, then you can optionally specify the date
that you wish to anchor your intervals to begin from.  If NULL (default)
then the intervals will start at the minimum value contained in the
\code{date_index} column. Note that the class of \code{firstdate} must be \code{Date} if
the \code{date_index} column is Date, POSIXct, POSIXlt, or character and integer
otherwise.}
}
\value{
An \code{incidence2} object.  This is a subclass of
\code{\link[=build_incidence]{incidence_df}} and aggregated count of observations
grouped according to the specified interval and, optionally, the given
groups.  By default it will contain the following columns:
\itemize{
\item \strong{date} / \strong{date_index}:  If the default interval of 1 day is used then
this will be the dates of the given observations and given the name
"date", otherwise, this will be values obtained from the specified date
grouping with column name "date_index" (See Interval specification below).
\item \strong{groups} (if specified): Column(s) containing the categories of the
given groups.
\item \strong{count} (or name of count variables): The aggregated observation counts.
}
}
\description{
Compute the incidence of events
}
\note{
\subsection{Input data (\code{date_index})}{
\itemize{
\item \strong{Decimal (numeric) dates}: will be truncated.
\item \strong{Character dates} should be in the unambiguous \code{yyyy-mm-dd} (ISO 8601)
format. Any other format will trigger an error.
}
}

\subsection{Interval specification (\code{interval})}{
\code{incidence()} uses the \href{https://cran.r-project.org/package=grates}{\code{grates}}
package to generate date groupings. The grouping used depends on the value
of \code{interval}. This can be specified as either an integer value or a more
standard specification such as "day", "week", "month", "quarter" or "year".
The format in this situation is similar to that used by \code{\link[=seq.Date]{seq.Date()}}
where these values can optionally be preceded by a (positive or negative)
integer and a space, or followed by "s".  When no prefix is given:
\itemize{
\item "week"    : uses the "grates_yearweek" class (see \code{\link[grates:as_yearweek]{grates::as_yearweek()}}).
\item "month"   : uses the "grates_month" class (see \code{\link[grates:as_month]{grates::as_month()}}).
\item "quarter" : uses the "grates_quarter" class (see \code{\link[grates:as_quarter]{grates::as_quarter()}}).
\item "year"    : uses the "grates_year" class (see \code{\link[grates:as_year]{grates::as_year()}}).
}

When a prefix is provided (e.g. 2 weeks) the output is an object of class
"period" (see \code{\link[=as_period]{as_period()}}).  Note that for the values "month",
"quarter" and "year" intervals are always chosen to start at the beginning
of the calendar equivalent.  If the input is an integer value the input is
treated as if it was specified in days (i.e. 2 and 2 days) produce the
same output.

The only interval values that do not produce these grouped classes are 1,
1L, "day" or "days" (both without prefix) are used.  In this situation the
returned object is of the standard "Date" class.
}

\subsection{Week intervals}{

It is possible to construct incidence objects standardized to any day of the
week. The default state is to use ISO 8601 definition of weeks, which start
on Monday. You can specify the day of the week an incidence object should
be standardised to by using the pattern "{n} {W} weeks" where "{W}"
represents the weekday in an English or current locale and "{n}" represents
the duration, but this can be ommitted.  Below are examples of specifying
weeks starting on different days assuming we had data that started on
2016-09-05, which is ISO week 36 of 2016:
\itemize{
\item interval = "2 monday weeks" (Monday 2016-09-05)
\item interval = "1 tue week" (Tuesday 2016-08-30)
\item interval = "1 Wed week" (Wednesday 2016-08-31)
\item interval = "1 Thursday week" (Thursday 2016-09-01)
\item interval = "1 F week" (Friday 2016-09-02)
\item interval = "1 Saturday week" (Saturday 2016-09-03)
\item interval = "Sunday week" (Sunday 2016-09-04)
}

It's also possible to use something like "3 weeks: Saturday"; In addition,
there are keywords reserved for specific days of the week:
\itemize{
\item interval = "week", (Default, Monday)
\item interval = "ISOweek"  (Monday)
\item interval = "EPIweek"  (Sunday)
\item interval = "MMWRweek" (Sunday)
}

}
}
\examples{
if (requireNamespace("outbreaks", quietly = TRUE)) {
  withAutoprint({
    data(ebola_sim_clean, package = "outbreaks")
    dat <- ebola_sim_clean$linelist

    # daily incidence
    incidence(dat, date_of_onset)

    # weekly incidence
    incidence(dat, date_of_onset, interval = "week")

    # starting on a Monday
    incidence(dat, date_of_onset, interval = "isoweek")

    # starting on a Sunday
    incidence(dat, date_of_onset, interval = "epiweek")

    # group by gender
    incidence(dat, date_of_onset, interval = 7, groups = gender)

    # group by gender and hospital
    incidence(dat, date_of_onset, interval = "2 weeks", groups = c(gender, hospital))
  })
}

# use of first_date
dat <- data.frame(dates = Sys.Date() + sample(-3:10, 10, replace = TRUE))
incidence(dat, dates, interval = "week", firstdate = Sys.Date() + 1)

}
