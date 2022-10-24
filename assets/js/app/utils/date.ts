const currentLocale = Intl.NumberFormat().resolvedOptions().locale;

export const parseDate = ({ dateString }: { dateString: string }) =>
  new Date(dateString);
export const formatDate = ({
  date,
  options,
}: {
  date: Date;
  options?: Intl.DateTimeFormatOptions;
}) => date.toLocaleString(currentLocale, options);
